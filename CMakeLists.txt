cmake_minimum_required(VERSION 3.12)
project(t_cose
	DESCRIPTION "t_cose"
	LANGUAGES C
	VERSION 1.0.1)

# Project options
set(MBEDTLS OFF CACHE BOOL "Use mbedTLS instead of OpenSSL")
set(BUILD_TESTS ON CACHE BOOL "Build tests")
set(BUILD_EXAMPLES ON CACHE BOOL "Build examples")

# Built-in CMake options
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Create shared instead of static libraries")

# Used in find_package() calls as preferred search paths
set(QCBOR_ROOT "" CACHE PATH "Installation prefix of QCBOR")
set(MbedTLS_ROOT "" CACHE PATH "Installation prefix of mbedTLS")
set(OpenSSL_ROOT "" CACHE PATH "Installation prefix of OpenSSL")

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
	message(STATUS "No build type selected, defaulting to Release")
	set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type" FORCE)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(T_COSE_SRC_COMMON
	src/t_cose_sign1_sign.c
	src/t_cose_parameters.c
	src/t_cose_sign1_verify.c
	src/t_cose_util.c
)

add_library(t_cose ${T_COSE_SRC_COMMON})
target_compile_options(t_cose PRIVATE -pedantic -Wall -ffunction-sections)
target_include_directories(t_cose PUBLIC inc PRIVATE src)

find_package(QCBOR REQUIRED)
target_link_libraries(t_cose PUBLIC QCBOR::QCBOR)

if(MBEDTLS)

	find_package(MbedTLS REQUIRED)
	target_link_libraries(t_cose PRIVATE MbedTLS::MbedCrypto)
	target_sources(t_cose PRIVATE crypto_adapters/t_cose_psa_crypto.c)
	target_compile_definitions(t_cose PRIVATE -DT_COSE_USE_PSA_CRYPTO=1)

else()

	find_package(OpenSSL REQUIRED)
	target_link_libraries(t_cose PRIVATE OpenSSL::Crypto)
	target_sources(t_cose PRIVATE crypto_adapters/t_cose_openssl_crypto.c)
	target_compile_definitions(t_cose PRIVATE -DT_COSE_USE_OPENSSL_CRYPTO=1)

endif()

include(GNUInstallDirs)

install(TARGETS t_cose
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
install(DIRECTORY inc/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

if (BUILD_EXAMPLES)

	if (MBEDTLS)
		add_executable(t_cose_basic_example_psa examples/t_cose_basic_example_psa.c)
		target_link_libraries(t_cose_basic_example_psa t_cose MbedTLS::MbedCrypto)
	else()
		add_executable(t_cose_basic_example_ossl examples/t_cose_basic_example_ossl.c)
		target_link_libraries(t_cose_basic_example_ossl t_cose OpenSSL::Crypto)
	endif()

endif()

if (BUILD_TESTS)

	enable_testing()

	# TODO

	#add_test()

endif()

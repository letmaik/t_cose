cmake_minimum_required(VERSION 3.12)
project(t_cose
	DESCRIPTION "t_cose"
	LANGUAGES C
	VERSION 1.0.1)

set(MBEDTLS OFF CACHE BOOL "Use mbedTLS instead of OpenSSL")

# Used in find_package() calls.
set(QCBOR_ROOT "" CACHE PATH "Installation prefix of QCBOR")
set(MbedTLS_ROOT "" CACHE PATH "Installation prefix of mbedTLS")
set(OpenSSL_ROOT "" CACHE PATH "Installation prefix of OpenSSL")

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

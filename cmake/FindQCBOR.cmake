#[=======================================================================[.rst:
FindQCBOR
-------

Finds the QCBOR library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``QCBOR::QCBOR``
  The QCBOR library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``QCBOR_FOUND``
  True if the system has the QCBOR library.
``QCBOR_INCLUDE_DIRS``
  Include directories needed to use QCBOR.
``QCBOR_LIBRARIES``
  Libraries needed to link to QCBOR.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``QCBOR_INCLUDE_DIR``
  The directory containing ``t_cose/``.
``QCBOR_LIBRARY``
  The path to the QCBOR library.

#]=======================================================================]

find_path(QCBOR_INCLUDE_DIR
  NAMES qcbor/qcbor.h
)
find_library(QCBOR_LIBRARY
  NAMES qcbor
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(QCBOR
  FOUND_VAR QCBOR_FOUND
  REQUIRED_VARS
    QCBOR_LIBRARY
    QCBOR_INCLUDE_DIR
)

if(QCBOR_FOUND)
  set(QCBOR_LIBRARIES "${QCBOR_LIBRARY}")
  set(QCBOR_INCLUDE_DIRS "${QCBOR_INCLUDE_DIR}")
endif()

if(QCBOR_FOUND AND NOT TARGET QCBOR::QCBOR)
  add_library(QCBOR::QCBOR UNKNOWN IMPORTED)
  set_target_properties(QCBOR::QCBOR PROPERTIES
    IMPORTED_LOCATION "${QCBOR_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${QCBOR_INCLUDE_DIR}"
  )
endif()

mark_as_advanced(
  QCBOR_INCLUDE_DIR
  QCBOR_LIBRARY
)

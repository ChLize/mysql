# Copyright (C) 2009 Sun Microsystems, Inc
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA 
 
#
# Headers which need to be checked for abi/api compatibility are in
# API_PREPROCESSOR_HEADER. plugin.h is tested implicitly via
# plugin_audit.h and plugin_ftparser.h.
#
# We use gcc specific preprocessing command and sed/diff, so it will 
# only be run  on Unix and only if gcc is used.
IF(CMAKE_COMPILER_IS_GNUCC AND CMAKE_SYSTEM_NAME MATCHES "Linux")
  IF(CMAKE_C_COMPILER MATCHES "ccache$")
    SET(COMPILER ${CMAKE_C_COMPILER_ARG1})
    STRING(REGEX REPLACE "^ " "" COMPILER ${COMPILER})
  ELSE()
    SET(COMPILER ${CMAKE_C_COMPILER})
  ENDIF()
  SET(API_PREPROCESSOR_HEADER
    ${CMAKE_SOURCE_DIR}/include/mysql/plugin_audit.h
    ${CMAKE_SOURCE_DIR}/include/mysql/plugin_ftparser.h
    ${CMAKE_SOURCE_DIR}/include/mysql.h
    ${CMAKE_SOURCE_DIR}/include/mysql/psi/psi_abi_v1.h
    ${CMAKE_SOURCE_DIR}/include/mysql/psi/psi_abi_v2.h
    ${CMAKE_SOURCE_DIR}/include/mysql/client_plugin.h
    ${CMAKE_SOURCE_DIR}/include/mysql/plugin_auth.h
  )

  ADD_CUSTOM_TARGET(abi_check ALL
  COMMAND ${CMAKE_COMMAND} 
    -DCOMPILER=${COMPILER}
    -DSOURCE_DIR=${CMAKE_SOURCE_DIR}
    -DBINARY_DIR=${CMAKE_BINARY_DIR}
    "-DABI_HEADERS=${API_PREPROCESSOR_HEADER}"
    -P ${CMAKE_SOURCE_DIR}/cmake/do_abi_check.cmake
    VERBATIM
  )

  ADD_CUSTOM_TARGET(abi_check_all
  COMMAND ${CMAKE_COMMAND} 
    -DCOMPILER=${COMPILER} 
    -DSOURCE_DIR=${CMAKE_SOURCE_DIR}
    -DBINARY_DIR=${CMAKE_BINARY_DIR}
    "-DABI_HEADERS=${API_PREPROCESSOR_HEADER}"
    -P ${CMAKE_SOURCE_DIR}/cmake/do_abi_check.cmake
    VERBATIM
  )
ENDIF()

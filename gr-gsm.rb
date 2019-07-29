class GrGsm < Formula
  homepage "https://github.com/ptrkrysik/gr-gsm"
  head "https://github.com/ptrkrysik/gr-gsm.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "swig" => :build
  depends_on "cppunit" => :build
  depends_on "boost"
  depends_on "gnuradio"
  depends_on "libosmocore"
  depends_on "librtlsdr"
  depends_on "gr-osmosdr"

  patch :DATA

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      ENV.prepend_create_path "GRC_BLOCKS_PATH", Formula["gr-osmosdr"].opt_prefix/"share/gnuradio/grc/blocks"

      args = %W[
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=NO
        -DCMAKE_SKIP_BUILD_RPATH=NO
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=NO
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
      ] + std_cmake_args

      ENV.deparallelize
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 27a3df7..5126d77 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -230,9 +230,6 @@ if(APPLE)
     if(NOT CMAKE_INSTALL_RPATH)
         set(cmakE_INSTALL_RPATH  ${CMAKE_INSTALL_PREFIX}/${GR_LIBRARY_DIR} CACHE PATH "Library Install RPath" FORCE)
     endif(NOT CMAKE_INSTALL_RPATH)
-    if(NOT CMAKE_BUILD_WITH_INSTALL_RPATH)
-        set(CMAKE_BUILD_WITH_INSTALL_RPATH ON CACHE  BOOL "Do Build Using Library Install RPath" FORCE)
-    endif(NOT CMAKE_BUILD_WITH_INSTALL_RPATH)
 endif(APPLE)
 
 ########################################################################
diff --git a/cmake/Modules/GrccCompile.cmake b/cmake/Modules/GrccCompile.cmake
index 4a917c5..cdd23ac 100644
--- a/cmake/Modules/GrccCompile.cmake
+++ b/cmake/Modules/GrccCompile.cmake
@@ -42,7 +42,7 @@ macro(GRCC_COMPILE file_name)
         ADD_CUSTOM_COMMAND(
             OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${file_name}
             COMMAND "${CMAKE_COMMAND}"
-                -E env PYTHONPATH="${PYTHONPATH}" GRC_BLOCKS_PATH=${CMAKE_SOURCE_DIR}/grc
+                -E env PYTHONPATH="${PYTHONPATH}" GRC_BLOCKS_PATH=${CMAKE_SOURCE_DIR}/grc:${GRC_BLOCKS_PATH}
                 ${PC_GNURADIO_RUNTIME_PREFIX}/${GR_RUNTIME_DIR}/grcc -d ${CMAKE_CURRENT_BINARY_DIR}
                 ${CMAKE_CURRENT_SOURCE_DIR}/${file_name}.grc
             COMMAND "${CMAKE_COMMAND}" -E rename ${CMAKE_CURRENT_BINARY_DIR}/${file_name}.py ${CMAKE_CURRENT_BINARY_DIR}/${file_name}

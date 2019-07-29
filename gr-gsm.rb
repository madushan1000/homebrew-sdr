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
  depends_on "madushan1000/sdr/gr-osmosdr"

  patch :DATA

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
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

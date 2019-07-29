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

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      args = %W[
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=NO
        -DCMAKE_SKIP_INSTALL_RPATH:YES
        -DCMAKE_SKIP_RPATH=YES
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
      ] + std_cmake_args

      ENV.deparallelize
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end

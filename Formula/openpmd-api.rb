class OpenpmdApi < Formula
  desc "C++ & Python API for Scientific I/O with openPMD"
  homepage "https://openpmd-api.readthedocs.io"
  url "https://github.com/openPMD/openPMD-api/archive/refs/tags/0.17.1.tar.gz"
  sha256 "cd4340dc17b41e4fafd0d2893af23a1bee82d169f2b2ca40d012b79c87c564d8"
  head "https://github.com/openPMD/openPMD-api.git", branch: "dev"

  depends_on "cmake" => :build
  depends_on "adios2"
  depends_on "hdf5-mpi"
  depends_on "mpi4py"
  depends_on "nlohmann-json"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "pybind11"
  depends_on "python@3.14"
  depends_on "toml11"

  def install
    args = std_cmake_args + %W[
      -DopenPMD_USE_MPI=ON
      -DopenPMD_USE_HDF5=ON
      -DopenPMD_USE_ADIOS2=ON
      -DopenPMD_USE_PYTHON=ON
      -DopenPMD_SUPERBUILD=OFF
      -DPython_EXECUTABLE=#{python3}
      -DopenPMD_INSTALL_PYTHONDIR=#{Language::Python.site_packages(python3)}
      -DBUILD_TESTING=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    # openPMD.pc needs CMAKE_INSTALL_{BIN,INCLUDE}DIR, but GNUInstallDirs is skipped if CMAKE_INSTALL_LIBDIR is set
    args += %w[-DCMAKE_INSTALL_BINDIR=bin -DCMAKE_INSTALL_INCLUDEDIR=include]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"examples").install "examples/5_write_parallel.cpp"
    (pkgshare/"examples").install "examples/5_write_parallel.py"
  end

  test do
    system "mpic++", "-std=c++17",
           (pkgshare/"examples/5_write_parallel.cpp"),
           "-I#{opt_include}",
           "-L#{opt_lib}", "-Wl,-rpath,#{opt_lib}",
           "-lopenPMD"
    system "mpiexec",
           "-n", "2",
           "./a.out"
    assert_path_exists testpath/"../samples/5_parallel_write.h5"

    system python3, "-c", "import openpmd_api"

    system "mpiexec",
           "-n", "2",
           python3,
           "-m", "mpi4py",
           (pkgshare/"examples/5_write_parallel.py")
    assert_path_exists testpath/"../samples/5_parallel_write_py.h5"
  end
end

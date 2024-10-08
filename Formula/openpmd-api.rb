class OpenpmdApi < Formula
  desc "C++ & Python API for Scientific I/O with openPMD"
  homepage "https://openpmd-api.readthedocs.io"
  url "https://github.com/openPMD/openPMD-api/archive/0.16.0.tar.gz"
  sha256 "b52222a4ab2511f9e3f6e21af222f57ab4fb6228623024fc5d982066333e104f"
  head "https://github.com/openPMD/openPMD-api.git", :branch => "dev"

  depends_on "cmake" => :build
  depends_on "adios2"
  #depends_on "catch2"  # we still use 2.X
  depends_on "hdf5-mpi"
  depends_on "mpi4py"
  depends_on "nlohmann-json"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "pybind11"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    args = std_cmake_args + %W[
      -DopenPMD_USE_MPI=ON
      -DopenPMD_USE_HDF5=ON
      -DopenPMD_USE_ADIOS2=ON
      -DopenPMD_USE_PYTHON=ON
      -DopenPMD_USE_INTERNAL_PYBIND11=OFF
      -DopenPMD_USE_INTERNAL_CATCH=ON
      -DPython_EXECUTABLE=#{which(python3)}
      -DBUILD_TESTING=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    (pkgshare/"examples").install "examples/5_write_parallel.cpp"
    (pkgshare/"examples").install "examples/5_write_parallel.py"

    # environment setups
    # TODO: PYTHONPATH?
    # bin.env_script_all_files("#{libexec}/lib/pkgconfig", :PKG_CONFIG_PATH => ENV["PKG_CONFIG_PATH"])
  end

  test do
    system "mpic++", "-std=c++17",
           (pkgshare/"examples/5_write_parallel.cpp"),
           "-I#{opt_include}",
           "-lopenPMD"
    system "mpiexec",
           "-n", "2",
           "./a.out"
    assert_predicate testpath/"../samples/5_parallel_write.h5", :exist?

    system "#{Formula["python"].opt_bin}/python3",
           "-c", "import openpmd_api"

    system "mpiexec",
           "-n", "2",
           "#{Formula["python"].opt_bin}/python3",
           "-m", "mpi4py",
           (pkgshare/"examples/5_write_parallel.py")
    assert_predicate testpath/"../samples/5_parallel_write_py.h5", :exist?
  end
end

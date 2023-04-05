class OpenpmdApi < Formula
  desc "C++ & Python API for Scientific I/O with openPMD"
  homepage "https://openpmd-api.readthedocs.io"
  url "https://github.com/openPMD/openPMD-api/archive/0.15.1.tar.gz"
  sha256 "0e81652152391ba4d2b62cfac95238b11233a4f89ff45e1fcffcc7bcd79dabe1"
  head "https://github.com/openPMD/openPMD-api.git", :branch => "dev"

  depends_on "cmake" => :build
  # pkg-config (add for downstream convenience?)
  # adios (no package)
  depends_on "adios2"
  #depends_on "catch2"  # we still use 2.X
  depends_on "hdf5-mpi"
  depends_on "mpi4py"
  depends_on "nlohmann-json"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "pybind11"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  # forgot to bump version.hpp in 0.15.1
  patch do
    url "https://github.com/openPMD/openPMD-api/pull/1417.patch?full_index=1"
    sha256 "c306483f1f94b308775a401c9cd67ee549fac6824a2264f5985499849fe210d5"
  end

  def install
    args = std_cmake_args + %W[
      -DopenPMD_USE_MPI=ON
      -DopenPMD_USE_HDF5=ON
      -DopenPMD_USE_ADIOS1=OFF
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

class Ffc < Formula
  desc "FEniCS Form Compiler for finite element variational forms"
  homepage "https://bitbucket.org/fenics-project/ffc"
  url "https://bitbucket.org/fenics-project/ffc/downloads/ffc-1.6.0.tar.gz"
  sha256 "382e7713fe759694e5f07506b144eeead681e169e5a34c164ef3da30eddcc1c6"
  head "https://bitbucket.org/fenics-project/ffc.git"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build
  depends_on "numpy" => :python

  depends_on "optimizers/fenics/fiat"
  depends_on "optimizers/fenics/ufl"

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def pyver
    IO.popen("python -c 'import sys; print sys.version[:3]'").read.strip
  end

  def install
    ENV.deparallelize
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"

    resource("six").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", lib/"python#{pyver}/site-packages"
    system "python", *Language::Python.setup_install_args(prefix)

    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system "python", "test.py"
    end
  end
end

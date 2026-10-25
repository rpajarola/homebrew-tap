class TmeRp < Formula
  desc "Machine Emulator for Sun-2, Sun-3, Sun-4c and UltraSPARC systems"
  homepage "https://github.com/rpajarola/tme"
  url "https://github.com/rpajarola/tme/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b63f53f6bb5a6574f64081a6e58f6d9d5a8f234d18fd839918631c92c46b9e17"
  license "BSD-4-Clause"
  revision 1
  head "https://github.com/rpajarola/tme.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "sdl2-compat"

  uses_from_macos "bison" => :build
  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Example machines are in #{HOMEBREW_PREFIX}/share/tme/examples.
    EOS
  end

  test do
    assert_match "Goodbye", pipe_output("#{bin}/tmesh 2>&1", "")
  end
end

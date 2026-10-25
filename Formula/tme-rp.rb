class TmeRp < Formula
  desc "Machine Emulator for Sun-2, Sun-3, Sun-4c and UltraSPARC systems"
  homepage "https://github.com/rpajarola/tme"
  url "https://github.com/rpajarola/tme/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c1114e4d393f3128d9d15ddb4eebc49b240eaa0e26990e14c463206b7519c92a"
  license "BSD-4-Clause"
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

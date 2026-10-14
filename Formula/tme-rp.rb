class TmeRp < Formula
  desc "Machine Emulator for Sun-2, Sun-3, Sun-4c and UltraSPARC systems"
  homepage "https://github.com/rpajarola/tme"
  url "https://github.com/rpajarola/tme/archive/refs/tags/v0.12rc7.tar.gz"
  sha256 "c6e7809320ab80c6e4bf8c5efa683e7cab8b4d3d2fe26a925c34ce925624c086"
  license "BSD-4-Clause"
  head "https://github.com/rpajarola/tme.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "sdl2-compat"

  uses_from_macos "bison" => :build

  on_macos do
    depends_on "gettext"
  end

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

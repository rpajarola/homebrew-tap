class GxemulRp < Formula
  desc "Full-system emulator for MIPS, ARM, PowerPC, M88K, SuperH and other machines"
  homepage "https://github.com/rpajarola/gxemul"
  url "https://github.com/rpajarola/gxemul/archive/refs/tags/v1.0.4.tar.gz"
  version "1.0.4"
  sha256 "a837bdb25ea3499ed45401c5ac0aeb1adc174da3a5ce4ec1d168de0073104ace"
  license "BSD-3-Clause"
  head "https://github.com/rpajarola/gxemul.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "libx11"

  def install
    ENV["PREFIX"] = prefix
    ENV["GXEMUL_VERSION"] = version.to_s
    system "./configure"
    system "make"
    system "make", "install", "MANDIR=#{man}"
  end

  def caveats
    <<~EOS
      Framebuffers need an X server, e.g. XQuartz (brew install --cask xquartz).
    EOS
  end

  test do
    assert_match "GXemul #{version}", shell_output("#{bin}/gxemul -V 2>&1", 1)
  end
end

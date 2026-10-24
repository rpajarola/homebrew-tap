class Mirrortools < Formula
  desc "Mirror HTTP, FTP, archive.org, IMAP and other services to local disk"
  homepage "https://github.com/rpajarola/mirrortools"
  url "https://github.com/rpajarola/mirrortools/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "0f77027fa97e492e719fa537d2c6f355dc13ae6ea5de52d8a38268bcdff52139"
  license "GPL-3.0-only"
  head "https://github.com/rpajarola/mirrortools.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rpajarola/mirrortools/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"mirror"), "./cmd/mirror"
    man1.install Dir["man/*.1"]
    doc.install "README.md"
    {
      "archiveorg" => "archiveorg", "ftpmirror" => "ftp", "gopher" => "gopher", "gphotos" => "gphotos",
      "groupsio" => "groupsio", "httpmirror" => "http", "icloud" => "icloud"
    }.each do |dir, name|
      doc.install "#{dir}/README.md" => "#{name}.md"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mirror version")
    assert_match "archiveorg", shell_output("#{bin}/mirror 2>&1", 2)
  end
end

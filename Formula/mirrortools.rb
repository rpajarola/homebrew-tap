class Mirrortools < Formula
  desc "Mirror HTTP, FTP, archive.org, IMAP and other services to local disk"
  homepage "https://github.com/rpajarola/mirrortools"
  url "https://github.com/rpajarola/mirrortools/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "26a4dacaee644ebbafe7c2a5a34508ef2804af0802616b8d361e64a0472c359f"
  license "GPL-3.0-only"
  head "https://github.com/rpajarola/mirrortools.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rpajarola/mirrortools/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"mirror"), "./cmd/mirror"
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

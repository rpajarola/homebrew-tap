class Gobootd < Formula
  desc "Boot server for old and unusual machines"
  homepage "https://github.com/rpajarola/gobootd"
  url "https://github.com/rpajarola/gobootd/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3d7d03c790dd601d700c13cd3154ec6989a7b5b84e06d6154b3e6cea30c50908"
  license "GPL-3.0-only"
  head "https://github.com/rpajarola/gobootd.git", branch: "main"

  depends_on "go" => :build
  uses_from_macos "libpcap"

  def install
    ldflags = "-X github.com/rpajarola/gobootd/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"bootd"), "./cmd/bootd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"bootbridge"), "./cmd/bootbridge"
    (pkgshare/"examples").install "etc/bootd.hcl", "etc/bootbridge.hcl"
    doc.install "README.md", "cmd/bootbridge/README.md" => "bootbridge.md"
    man5.install Dir["man/*.5"]
    man8.install Dir["man/*.8"]

    inreplace "packaging/macos/bootd.hcl" do |s|
      s.gsub! "/usr/local/var/bootd", var/"bootd"
      s.gsub! "/usr/local/share/gobootd/examples", pkgshare/"examples"
      s.gsub! "sudo bootd check -c /usr/local/etc/bootd.hcl", "bootd check -c #{etc}/bootd.hcl"
      s.gsub! "/usr/local/etc/bootbridge.hcl", etc/"bootbridge.hcl"
      s.gsub! "so it is readable only by root and\n# the nobody group, which bootd runs as.",
              "so keep it readable only by you."
    end
    inreplace "packaging/macos/bootbridge.hcl" do |s|
      s.gsub! "/usr/local/share/gobootd/examples", pkgshare/"examples"
      s.gsub!(/sudo launchctl bootstrap .*$/, "sudo bootbridge -c #{etc}/bootbridge.hcl")
    end
    etc.install "packaging/macos/bootd.hcl", "packaging/macos/bootbridge.hcl"
  end

  post_install_steps do
    mkdir_p "bootd", base: :var
  end

  def caveats
    <<~EOS
      Edit #{etc}/bootd.hcl and check it with:
        bootd check -c #{etc}/bootd.hcl
      bootbridge needs root to capture on an interface:
        sudo bootbridge -c #{etc}/bootbridge.hcl
    EOS
  end

  service do
    run [opt_bin/"bootd", "run", "-c", etc/"bootd.hcl"]
    keep_alive successful_exit: false
    log_path var/"log/bootd.log"
    error_log_path var/"log/bootd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bootd version")
    assert_match version.to_s, shell_output("#{bin}/bootbridge -version")
    (testpath/"bootd.hcl").write <<~HCL
      network "lab" {
        address = "192.168.1.250/24"
        udp     = "127.0.0.1:4712"
      }
      service "tftp" {}
      host "kali" {
        mac = "08:00:20:01:02:03"
        ip  = "192.168.1.5"
      }
    HCL
    system bin/"bootd", "check", "-q", "-c", testpath/"bootd.hcl"
  end
end

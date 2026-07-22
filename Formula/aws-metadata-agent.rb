class AwsMetadataAgent < Formula
  desc "Run aws-runas as a native EC2 metadata service"
  homepage "https://github.com/so1omon563/aws-metadata-agent"
  url "https://github.com/so1omon563/aws-metadata-agent/releases/download/v0.3.3/aws-metadata-agent-v0.3.3.tar.gz"
  sha256 "c5c894b5cd56baa7781aa4b7c82c5f2b1508159fca3913a5e930b75a0873f853"
  license "MIT"

  depends_on :macos

  def install
    libexec.install "VERSION", "bootstrap.sh", "install.sh", "uninstall.sh"
    libexec.install "bin", "launchd", "libexec"

    (bin/"aws-metadata").write_env_script(
      libexec/"bin/aws-metadata",
      AWS_METADATA_PACKAGE_ROOT: libexec,
      AWS_METADATA_VERSION_FILE: libexec/"VERSION",
      AWS_METADATA_PACKAGE_CLI:  bin/"aws-metadata",
    )
  end

  def caveats
    <<~EOS
      Homebrew installed only the unprivileged package payload.
      Complete the privileged service setup explicitly:

        aws-metadata setup

      The supported Homebrew host boundary is Apple Silicon macOS 26.
    EOS
  end

  test do
    assert_equal "0.3.3\n", shell_output("#{bin}/aws-metadata version")
    assert_match "Usage:", shell_output("#{bin}/aws-metadata setup --help")

    package_root = testpath/"package"
    package_root.mkpath
    bootstrap_marker = testpath/"bootstrapped"
    install_marker = testpath/"installed"
    package_cli = testpath/"aws-metadata"

    (package_root/"bootstrap.sh").write <<~SH
      #!/bin/bash
      set -eu
      /usr/bin/touch "#{bootstrap_marker}"
    SH
    (package_root/"bootstrap.sh").chmod 0755

    (package_root/"install.sh").write <<~SH
      #!/bin/bash
      set -eu
      [[ -f "#{bootstrap_marker}" ]]
      [[ ${1:-} == --package-cli ]]
      [[ ${2:-} == "#{package_cli}" ]]
      /usr/bin/touch "#{install_marker}"
    SH
    (package_root/"install.sh").chmod 0755

    package_cli.write("#!/bin/bash\n")
    package_cli.chmod 0755
    ENV["HOME"] = testpath.to_s
    ENV["PATH"] = "/usr/bin:/bin"
    ENV["AWS_METADATA_PACKAGE_ROOT"] = package_root.to_s
    ENV["AWS_METADATA_PACKAGE_CLI"] = package_cli.to_s

    shell_output("#{libexec}/bin/aws-metadata setup")
    assert_path_exists bootstrap_marker
    assert_path_exists install_marker
  end
end

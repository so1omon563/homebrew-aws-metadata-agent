class AwsMetadataAgent < Formula
  desc "Run aws-runas as a native EC2 metadata service"
  homepage "https://github.com/so1omon563/aws-metadata-agent"
  url "https://github.com/so1omon563/aws-metadata-agent/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "103ffa45d51a9dc6f750985810225064a15cfe0a5ca79dbd4dfa96eb87512850"
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
    assert_equal "0.2.0\n", shell_output("#{bin}/aws-metadata version")
    assert_match "Usage:", shell_output("#{bin}/aws-metadata setup --help")
  end
end

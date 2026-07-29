class AwsMetadataAgent < Formula
  desc "Run aws-runas as a native EC2 metadata service"
  homepage "https://github.com/so1omon563/aws-metadata-agent"
  url "https://github.com/so1omon563/aws-metadata-agent/releases/download/v0.4.0/aws-metadata-agent-v0.4.0.tar.gz"
  sha256 "6c420a6352ae7b2ac818cb6651cadb61f465f77ab037f79b50772cf9afe780c6"
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
      For sudo-free user mode:

        aws-metadata setup --mode user

      For transparent link-local system mode:

        aws-metadata setup --mode system

      The supported Homebrew host boundary is Apple Silicon macOS 26.
    EOS
  end

  test do
    assert_equal "0.4.0\n", shell_output("#{bin}/aws-metadata version")
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
      [[ ${3:-} == --mode ]]
      [[ ${4:-} == user ]]
      /usr/bin/touch "#{install_marker}"
    SH
    (package_root/"install.sh").chmod 0755

    package_cli.write("#!/bin/bash\n")
    package_cli.chmod 0755
    ENV["HOME"] = testpath.to_s
    ENV["PATH"] = "/usr/bin:/bin"
    ENV["AWS_METADATA_PACKAGE_ROOT"] = package_root.to_s
    ENV["AWS_METADATA_PACKAGE_CLI"] = package_cli.to_s

    shell_output("#{libexec}/bin/aws-metadata setup --mode user")
    assert_path_exists bootstrap_marker
    assert_path_exists install_marker
  end
end

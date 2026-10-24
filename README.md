# SideTorrent — unsigned iOS IPA

SideTorrent is a fork of [iTorrent](https://github.com/XITRIX/iTorrent), an iOS torrent client.

## Build an unsigned IPA

This repository builds **one unsigned IPA** with GitHub Actions. It does not require Apple signing certificates, provisioning profiles, AltStore metadata, or App Store Connect credentials.

1. Open the **Actions** tab in this repository.
2. Run **Unsigned IPA Build** manually, or push to the `unsigned-ipa-only` branch.
3. Open the completed workflow run.
4. Download the `iTorrent-unsigned-ipa` artifact. It contains `iTorrent-unsigned.ipa`.

Release tags matching `v*.*.*-*` also trigger the unsigned build.

## Important

The IPA is intentionally **unsigned**. It is a build artifact, not a ready-to-install signed app; iOS will not install or launch it normally until it is signed using a legitimate signing workflow compatible with your device and installation method.

The app's torrent-client functionality and its existing source code are retained. Only the distribution workflow has been simplified to produce a single unsigned IPA.

## Upstream project

The original app and its licensing are maintained by the upstream [XITRIX/iTorrent](https://github.com/XITRIX/iTorrent) project. See [LICENSE.txt](LICENSE.txt) for license terms.

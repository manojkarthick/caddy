# Caddy + Porkbun

Add [DNS verification capabilities](https://caddy.community/t/how-to-use-dns-provider-modules-in-caddy-2/8148) to Caddy running in a container.
Reference [blog post](https://major.io/p/caddy-porkbun/) about how to use this container with Porkbun.

## Container vulnerability scanning

GitHub Actions runs Trivy against the final image, covering OS packages and
compiled Go dependencies. Pull requests scan the local build without publishing;
published builds are scanned by their immutable registry digest.

Pull requests also check the custom binary's version, Porkbun module registration,
and a Porkbun DNS-challenge configuration using dummy credentials. This does not
issue a certificate or contact Porkbun; live DNS validation needs real credentials.

The **Scan published container** workflow also rescans the published `:main` image
every Monday at 15:29 UTC, resolving its digest first, so newly disclosed
vulnerabilities can be found without rebuilding. It can also be run manually.

Scans are initially report-only: all severities, including vulnerabilities without
fixes, appear in the Trivy step's Actions logs. Findings do not block releases;
scanner errors still fail the workflow. After reviewing the baseline, we can
enable a gate for fixable HIGH/CRITICAL vulnerabilities.

Trivy's Go-binary results match module versions, not necessarily reachable
vulnerable functions. Review each advisory against the built binary and deployed
configuration before claiming exploitability or accepting risk. Unfixed findings
remain visible; the scans do not use vulnerability suppressions.

.PHONY: setup-fmt
setup-fmt:
	@go install "mvdan.cc/sh/v3/cmd/shfmt@latest"
	shfmt --version

.PHONY: fmt
fmt:
	@shfmt -i 4 -l -w -ci -sr -kp -f .

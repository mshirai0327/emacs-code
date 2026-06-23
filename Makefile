.PHONY: doctor check

doctor:
	bash scripts/doctor.sh

check:
	EC_NO_PACKAGE_INSTALL=1 emacs --batch -l init.el

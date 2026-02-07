#!/usr/sbin/bash
#
#   buildenv_optimize.sh - Extend BUILDENV/OPTIONS validation for makepkg-optimize
#
#   This overrides the lint_buildenv function from buildenv.sh to add
#   makepkg-optimize's custom BUILDENV and OPTIONS entries to the known lists.
#

MAKEPKG_LIBRARY=${MAKEPKG_LIBRARY:-'/usr/share/makepkg'}

source "$MAKEPKG_LIBRARY/util/message.sh"

# Override lint_buildenv to include makepkg-optimize options
lint_buildenv() {
	local ret=0 kopt
	local known_buildenv=(ccache check color distcc sign pgo graphite polly rice rice-clang mold bolt buildcache lld aocc relocs relocsgcc)
	local known_option=(autodeps debug docs emptydirs libtool lto purge staticlibs strip zipman upx optipng svgo)

	for i in "${BUILDENV[@]}"; do
		for kopt in "${known_buildenv[@]}"; do
			if [[ $i = "$kopt" || $i = "!$kopt" ]]; then
				continue 2
			fi
		done

		error "$(gettext "%s array contains unknown option '%s'")" "BUILDENV" "$i"
		ret=1
	done

	for i in "${OPTIONS[@]}"; do
		for kopt in "${known_option[@]}"; do
			if [[ $i = "$kopt" || $i = "!$kopt" ]]; then
				continue 2
			fi
		done

		error "$(gettext "%s array contains unknown option '%s'")" "OPTIONS" "$i"
		ret=1
	done
}

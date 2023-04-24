setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/ddev-mailpit
  mkdir -p $TESTDIR
  export PROJNAME=ddev-mailpit
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

health_checks() {
  # Confirm site is available. ie. DDEV didn't fail
  ddev exec "curl -s https://localhost:443/"

  # Check Healthcheck endpoints. https://github.com/axllent/mailpit/wiki/Healthcheck-endpoints
  ddev exec "curl --silent --head mailpit:8025/livez" | grep "HTTP/1.1 200 OK"
  ddev exec "curl --silent --head mailpit:8025/readyz" | grep "HTTP/1.1 200 OK"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  health_checks
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get tyler36/ddev-mailpit with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get tyler36/ddev-mailpit
  ddev restart >/dev/null
  health_checks
}

@test "install PHP override for Drupal projects" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3

  ddev get ${DIR}
  ddev restart

  # PHP should NOT have a custom config.
  ddev . php --info | grep -v "smtp-addr mailpit:1025"

  # Set the project type and install the addon again
  ddev config --project-type=drupal10
  ddev get ${DIR}
  ddev restart

  # Check if PHP mail was updated
  ddev . php --info | grep "smtp-addr mailpit:1025"
}

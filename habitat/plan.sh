pkg_name=VotingApp-Result-Plan
pkg_origin=kbhimanavarjula
pkg_version="1.0.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
#pkg_license=('Apache-2.0')
pkg_source="https://github.com/nvtuluva/VotingApp"
pkg_shasum="2c1a9dfb501d75811abc1f3cd765e4cad3add3131dc8fa37fbf1c828bb103ad8"
pkg_deps=(core/docker core/curl core/node)
pkg_build_deps=(core/git core/postgresql)
pkg_binds=( [database]="port" )
pkg_expose=(5001)
pkg_svc_user="root"
pkg_binds=(
[db]
adapter = "postgresql"
name = "Votingapp_production"
user = "Votingapp"
password = "myrailsapp"
)
do_build()
{
        # This installs both npm as well as the nconf module we listed as a dependency in package.json.
        cd VotingApp/result
        npm install
}

do_download()
{
        build_line "do_download() =================================================="
        cd ${HAB_CACHE_SRC_PATH}
        build_line "\$pkg_dirname=${pkg_dirname}"
        build_line "\$pkg_filename=${pkg_filename}"
        if [ -d "${pkg_dirname}" ];
        then
            rm -rf ${pkg_dirname}
        fi
        mkdir ${pkg_dirname}
        cd ${pkg_dirname}
        GIT_SSL_NO_VERIFY=true git clone --branch master https://github.com/kbhimanavarjula/VotingApp.git
        return 0
}
do_clean()
{
        build_line "do_clean() ===================================================="
        return 0
}
do_unpack()
{
        # Nothing to unpack as we are pulling our code straight from github
        return 0
}
do_install() 
{
  # Copy our source files from HAB_CACHE_SRC_PATH to the nodejs-tutorial-app
  # package.  This is so that when Habitat calls "node server.js" at start-up, we
  # have the source files included in the package.
  cp VotingApp/result/package.json "$pkg_prefix/"
  cp VotingApp/result/server.js "$pkg_prefix/"
  # Copy over the nconf module to the package that we installed in do_build().
  mkdir -p "${pkg_prefix}/node_modules/"
  cp -vr VotingApp/result/* "${pkg_prefix}/node_modules/"
  cd VotingApp/result/
#  npm start
}
# We verify our own source code because we cloned from GitHub instead of
# providing a SHA-SUM of a tarball
do_verify()
{
            build_line "do_verify() ==================================================="
                return 0
}

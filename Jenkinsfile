node('master') {
    currentBuild.result = "SUCCESS"

    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 1, 'defaultBg': 2]) {

        try {
           stage 'Prepare'
                checkout scm

           stage 'Puppet Apply'
                def servers = ['front-2.dragon.lan',
                               'db-2.dragon.lan',
                               'ci-1.dragon.lan',
                               'log-1.dragon.lan',
                               'login-1.dragon.lan',
                               'app-3.dragon.lan',
                               'app-4.dragon.lan']
                for (server in servers) {
                   puppetApply server
                }
           stage 'Cleanup'
                print "Clean workspace"
                deleteDir()

        }catch (err) {
            currentBuild.result = "FAILURE"
            throw err
        }
    }
}

def puppetApply(server){
    print "Update ${server}"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'git --work-tree=/opt/pve --git-dir=/opt/pve/.git pull'"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'sudo /opt/pve/apply.sh'"
}

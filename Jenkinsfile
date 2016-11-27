node('master') {
    currentBuild.result = "SUCCESS"

    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 1, 'defaultBg': 2]) {

        try {
           stage 'Prepare'
                mattermostSend "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER}  ()"
                checkout scm

                def servers = ['front-2',
                               'db-2',
                               'login-1',
                               'app-3',
                               'app-4']
                for (server in servers) {
                   stage server
                   puppetApply server
                }

            stage 'ci-1'
                sh 'git --work-tree=/opt/pve --git-dir=/opt/pve/.git pull'
                sh 'sudo /opt/pve/apply.sh'

           stage 'Cleanup'
                print "Clean workspace"
                deleteDir()
                mattermostSend "Build finished - ${env.JOB_NAME} ${env.BUILD_NUMBER}  ()"

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

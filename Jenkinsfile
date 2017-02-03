node('master') {
    currentBuild.result = "SUCCESS"

    def servers = ['front-2',
                   'db-2',
                   'login-1',
                   'app-3',
                   'app-4']

    ansiColor('xterm'){
        try {
           stage 'Prepare'
                mattermostSend "${env.JOB_NAME} - Build ${env.BUILD_NUMBER} started."
                checkout scm

                for (server in servers) {
                   stage server
                   puppetApply server
                }

            stage 'ci-1'
                sh 'git --work-tree=/opt/puppet/pve --git-dir=/opt/puppet/pve/.git pull'
                sh 'sudo /opt/puppet/pve/apply.sh'

           stage 'Cleanup'
                print "Clean workspace"
                deleteDir()
                mattermostSend color: "good", message: "${env.JOB_NAME} - Build ${env.BUILD_NUMBER} finished."

        }catch (err) {
            currentBuild.result = "FAILURE"
            mattermostSend color: "bad", message: "${env.JOB_NAME} - Build ${env.BUILD_NUMBER} FAILED."
            throw err
        }
    }
}

def puppetApply(server){
    print "Update ${server}"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'git --work-tree=/opt/puppet/pve --git-dir=/opt/puppet/pve/.git pull'"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'sudo /opt/puppet/pve/apply.sh'"
}

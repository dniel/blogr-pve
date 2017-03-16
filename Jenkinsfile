node('master') {
    currentBuild.result = "SUCCESS"

    def servers = ['p-lb-01',
                   'p-lb-02',
                   'p-app-01',
                   'p-app-02',
                   'p-app-03',
                   'p-app-04',
                   'p-db-01',
                   'p-db-02',
                   'p-chat-01',
                   'p-log-01',
//                   't-lb-01',
                   't-app-01',
                   't-app-02',
                   't-db-01',
                   'd-app-01',
                   'd-db-01']

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
    sh "ssh -t -o StrictHostKeyChecking=no jenkins@${server} 'git --work-tree=/opt/puppet/pve --git-dir=/opt/puppet/pve/.git pull'"
    sh "ssh -t -o StrictHostKeyChecking=no jenkins@${server} 'sudo /opt/puppet/pve/apply.sh'"
}

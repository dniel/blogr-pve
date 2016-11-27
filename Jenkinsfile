node('master') {
    currentBuild.result = "SUCCESS"
    def messageHeader = """"| Server | Updated |
                            |:-------|:-------:|"""
    def messageBody = ""
    def messageFooter = ""

    def servers = ['front-2',
                   'db-2',
                   'login-1',
                   'app-3',
                   'app-4']

    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 1, 'defaultBg': 2]) {
        try {
           stage 'Prepare'
                mattermostSend "${env.JOB_NAME} - Build ${env.BUILD_NUMBER} started."
                checkout scm

                for (server in servers) {
                   stage server
                   puppetApply server
                   messageBody += "| ${server} | :white_check_mark: |"
                }

            stage 'ci-1'
                sh 'git --work-tree=/opt/pve --git-dir=/opt/pve/.git pull'
                sh 'sudo /opt/pve/apply.sh'

           stage 'Cleanup'
                print "Clean workspace"
                deleteDir()

                mattermostSend color: "good", message: (messageHeader + messageBody + messageFooter)
        }catch (err) {
            currentBuild.result = "FAILURE"
            mattermostSend color: "bad", message: (messageHeader + messageBody + messageFooter)
            throw err
        }
    }
}

def puppetApply(server){
    print "Update ${server}"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'git --work-tree=/opt/pve --git-dir=/opt/pve/.git pull'"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'sudo /opt/pve/apply.sh'"
}

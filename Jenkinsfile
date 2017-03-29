node('master') {
    currentBuild.result = "SUCCESS"

    ansiColor('xterm') {
        try {
            stage 'Prepare'
                mattermostSend "${env.JOB_NAME} - Build ${env.BUILD_NUMBER} started."
                checkout scm


                def response = httpRequest acceptType: 'APPLICATION_JSON',
                        contentType: 'APPLICATION_JSON', url: "http://consul.service.consul:8500/v1/catalog/nodes"

                def nodes = parseJsonText response.content
                for (node in nodes) {
                    mattermostSend color: "good", message: "Update ${node.Node} , ${node.Address}"
                    def server = node.Address
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

        } catch (err) {
            currentBuild.result = "FAILURE"
            mattermostSend color: "bad", message: "${env.JOB_NAME} - Build ${env.BUILD_NUMBER} FAILED."
            throw err
        }
    }
}


@NonCPS
def parseJsonText(String json) {
    new groovy.json.JsonSlurperClassic().parseText(json)
}

def puppetApply(server) {
    print "Update ${server}"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'git --work-tree=/opt/puppet/pve --git-dir=/opt/puppet/pve/.git pull'"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'sudo /opt/puppet/pve/apply.sh'"
}

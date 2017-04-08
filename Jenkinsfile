node('master') {
    currentBuild.result = "SUCCESS"

    ansiColor('xterm') {
        stage('Prepare') {
            mattermostSend "${env.JOB_NAME} - ${env.BUILD_NUMBER} started."
            checkout scm
            sh 'sudo /opt/puppet/pve/apply.sh'
            mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Build server was updated."
        }

        stage("Puppet Apply") {
            try {
                /**
                 * Retrieve Nodes from Consul HTTP API.
                 * https://www.consul.io/docs/agent/http.html
                 */
                def response = httpRequest "http://consul.service.consul:8500/v1/catalog/nodes"
                def nodes = parseJsonText response.content
                for (node in nodes) {
                    // retrieve status of serfHealth to check if node is online.
                    response = httpRequest "http://consul.service.consul:8500/v1/health/node/${node.Node}"
                    status = parseHealthCheck response

                    if (!node.Node.contains('p-ci-01') && status == "passing") {
                        mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Update ${node.Node} , ${node.Address}"
                        puppetApply node.Address
                    } else {
                        mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Ignore update ${node.Node} , ${node.Address}"
                    }
                }
                mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} ${nodes.size} nodes was updated."
            } catch (err) {
                currentBuild.result = "FAILURE"
                mattermostSend color: "bad", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} FAILED."
                throw err
            }
        }
    }
}

@NonCPS
def parseHealthCheck(response) {
    def health = parseJsonText response.content
    for (int i = 0; i < health.size; i++) {
        if (health[i].CheckID == 'serfHealth') return health[i].Status;
    }
}

/**
 * Use serializable version of JsonSlurper that
 * use response objects that are serializable.
 * @param json text
 * @return json objects
 */
@NonCPS
def parseJsonText(String json) {
    new groovy.json.JsonSlurperClassic().parseText(json)
}

def puppetApply(server) {
    print "Update ${server}"
    sh "rsync -rz --delete -e \"ssh -o StrictHostKeyChecking=no\" jenkins@${server}:/opt/puppet/pve/ /opt/puppet/pve"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'sudo /opt/puppet/pve/apply.sh'"
}

pipeline {
    agent {
        label 'jenkins-agent'
    }
    environment {
        REGISTRY = "cr.yandex/crps7usnpsm729ptcit7"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build & Push') {
            steps {
                script {
                    def services = [
                        "frontend": "src/frontend",
                        "adservice": "src/adservice",
                        "cartservice": "src/cartservice/src",
                        "checkoutservice": "src/checkoutservice",
                        "currencyservice": "src/currencyservice",
                        "emailservice": "src/emailservice",
                        "paymentservice": "src/paymentservice",
                        "productcatalogservice": "src/productcatalogservice",
                        "recommendationservice": "src/recommendationservice",
                        "shippingservice": "src/shippingservice",
                        "loadgenerator": "src/loadgenerator",
                        "shoppingassistantservice": "src/shoppingassistantservice"
                    ]
                    def builds = [:]
                    services.each { service, path ->
                        builds[service] = {
                            dir(path) {
                                sh """
                                docker build \
                                -t ${REGISTRY}/${service}:${IMAGE_TAG} .

                                docker push \
                                ${REGISTRY}/${service}:${IMAGE_TAG}
                                """
                            }
                        }
                    }
                    builds.each { name, build ->
                        build()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig-yc',
                        variable: 'KUBECONFIG')
                    ]) {
                    sh """
                    helm upgrade \
                    --install boutique \
                    helm-chart \
                    --namespace boutique \
                    --create-namespace \
                    --set images.repository=${REGISTRY} \
                    --set images.tag=${IMAGE_TAG}
                    """
                }
            }
        }
        stage('Rollout') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig-yc',
                        variable: 'KUBECONFIG')
                    ]) {
                    sh '''
                    for deployment in $(kubectl get deployments -n boutique -o name); do
                        kubectl rollout status $deployment -n boutique
                    done
                    '''
                }
            }
        }
    }
}
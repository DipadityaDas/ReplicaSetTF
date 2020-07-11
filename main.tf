provider "kubernetes" {
  config_context_cluster = "minikube"
}

resource "kubernetes_deployment" "mysql_rs" {
	metadata {
		name = "mysql-rs"
		labels = {
			dc = "IN"
		}
	}
	spec {
		replicas = 1
		selector {
			match_labels = {
				dc  = "IN"
				env = "dev"
			}
		}

		template {
			metadata {
				labels = {
					dc  = "IN"
					env = "dev"
				}
			}
			spec {
				container {
					image = "mysql:5.6"
					name  = "mysql-con"
					env {
						name  = "MYSQL_ROOT_PASSWORD"
						value = "redhat"
					}
					env {
						name  = "MYSQL_DATABASE"
						value = "wordpress"
					}
					env {
						name  = "MYSQL_USER"
						value = "dipaditya"
					}
					env {
						name  = "MYSQL_PASSWORD"
						value = "ddaspass"
					}
				}
			}
		}
	}
}

resource "kubernetes_deployment" "wp_rs" {
	metadata {
		name = "wp-rs"
		labels = {
			dc = "IN"
		}
	}
	spec {
		replicas = 1
		selector {
			match_labels = {
				dc  = "IN"
				app = "wp"
			}
		}
		template {
			metadata {
				labels = {
					dc  = "IN"
					app = "wp"
				}
			}
			spec {
				container {
					image = "wordpress:4.8-apache"
					name  = "wp-con"
					env {
						name  = "WORDPRESS_DB_HOST"
						value = kubernetes_deployment.mysql_rs.spec[0].template[0].spec[0].hostname
					}
					env {
						name = "WORDPRESS_DB_USER"
						value = "dipaditya"
					}
					env {
						name  = "WORDPRESS_DB_PASSWORD"
						value = "ddaspass"
					}
					env {
						name  = "WORDPRESS_DB_NAME"
						value = "wordpress"
					}
				}
			}
		}
	}
}

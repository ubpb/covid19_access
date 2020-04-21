server "ubpegasus18.upb.de", user: "ubpb", roles: %w{app web db}
server "ubperseus18.upb.de", user: "ubpb", roles: %w{app web}
set :deploy_to, "/ubpb/covid19access"
set :branch, "production"

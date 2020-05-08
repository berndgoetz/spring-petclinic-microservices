package org.springframework.samples.petclinic.api.security;

import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

@EnableWebFluxSecurity
public class InsecurityConfiguration {
    //@formatter:off
    @Bean
    public SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http) {
         http
              .authorizeExchange()
                   .anyExchange().permitAll();
         return http.build();
    }
}

package sk.itlama.k8sdemo;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class InfoController {

    @Value("${app.environment:development}")
    private String environment;

    @Value("${app.version:1.0.0}")
    private String version;

    @GetMapping("/api/health")
    public Map<String, String> health() {
        return Map.of("status", "healthy");
    }

    @GetMapping("/api/info")
    public Map<String, String> info() throws UnknownHostException {
        return Map.of(
            "application", "k8s-demo",
            "version", version,
            "environment", environment,
            "hostname", InetAddress.getLocalHost().getHostName()
        );
    }
}

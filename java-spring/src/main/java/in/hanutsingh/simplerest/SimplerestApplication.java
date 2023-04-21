package in.hanutsingh.simplerest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;


@SpringBootApplication
public class SimplerestApplication {

	public static void main(String[] args) {
		ConfigurableApplicationContext context = SpringApplication.run(SimplerestApplication.class, args);
	}

}

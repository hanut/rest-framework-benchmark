package in.hanutsingh.simplerest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import reactor.core.publisher.Mono;
import in.hanutsingh.simplerest.LoginRequest;
import in.hanutsingh.simplerest.LoginResponse;

@RestController
@RequestMapping("/")
public class SimplerestController {

	@PostMapping("/")
	public Mono<LoginResponse> saveOneInvoice(@RequestBody final LoginRequest credentials) {
		System.out.println(credentials);
		if (!credentials.getEmail().equals("hanutsingh@gmail.com") || !credentials.getPassword().equals("qweasd@123")) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Unauthorized");
		}
		LoginResponse resData = new LoginResponse();
		resData.setUsername("hanut");
		resData.setRole("super admin");
		return Mono.just(resData);
	}

}
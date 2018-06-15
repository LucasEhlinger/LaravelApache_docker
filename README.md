<<<<<<< HEAD
# Laravel and Apache Docker Image

ARM ready, tested on intel i7 and Raspberry-Pi 3 ARM 32b v7

## Deployment

with another dockerfile : 

    FROM lucasehlinger/laravel
    COPY directory/to/app/ /home
    RUN composer install
    RUN chgrp -R www-data storage /home/bootstrap/cache && chmod -R ug+rwx storage /home/bootstrap/cache
    RUN php artisan key:generate && php artisan view:cache

with docker-compose

    version: '2'
    services:
      web:
        build : lucasehlinger/laravel
        ports :
          - "80:80"
        expose:
          - 80
        volumes:
          - ./:/home

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


=======
# LaravelApache_docker
>>>>>>> parent of bd00f89... initial commit

FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    python-pip python-dev uwsgi-plugin-python \
    nginx supervisor
COPY nginx/nginx.conf /etc/nginx/sites-available/
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY app /var/www/app

RUN mkdir -p /var/log/nginx/app /var/log/uwsgi/app /var/log/supervisor \
    && rm /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && pip install -U pip \ 
    &&  pip install -r /var/www/app/requirements.txt \
    && chown -R www-data:www-data /var/www/app \
    && chown -R www-data:www-data /var/log

EXPOSE 80

CMD ["supervisord", "-n"]

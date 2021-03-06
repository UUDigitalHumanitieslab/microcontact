"""microcontact URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.8/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls import include, url
from django.conf.urls.static import static
from django.contrib import admin

from .index import index
from .views import proxy_maps

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include('recordings.urls')),
    url(r'^$', index),
    url(r'^proxymaps', proxy_maps)
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# api/urls.py

from django.conf.urls import url, include
from rest_framework import routers

from recordings import views

router = routers.DefaultRouter()
router.register(r'dialects', views.DialectViewSet)
router.register(r'languages', views.LanguageViewSet)
router.register(r'countries', views.CountryViewSet)
router.register(r'age-categories', views.AgeCategoryViewSet)
router.register(r'recordings', views.RecordingViewSet)

urlpatterns = [
    url(r'^', include(router.urls)),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
]

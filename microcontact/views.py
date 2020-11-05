import requests

from django.conf import settings
from django.http import HttpResponse

def proxy_maps(request):
    url = 'https://maps.google.com/maps/api/js'
    payload = {'v': 3, 'libraries': 'places', 'key': settings.GMAPIKEY}
    response = requests.get(url, params=payload)
    return HttpResponse(response)
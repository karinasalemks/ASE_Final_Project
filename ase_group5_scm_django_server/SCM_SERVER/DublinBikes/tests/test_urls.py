from django.test import SimpleTestCase
from django.urls import reverse, resolve
from DublinBikes.views import bikeAvailability

class TestUrls(SimpleTestCase):

    # this checks that the url is calling the correct function
    def test_bike_availability_url_is_resolved(self):
        url = reverse('availability')
        self.assertEquals(resolve(url).func, bikeAvailability)
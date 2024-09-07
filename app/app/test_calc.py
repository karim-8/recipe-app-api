
"""
Sample Test
"""

from django.test import SimpleTestCase
from app import calc

class SimpleTests(SimpleTestCase):
    def test_add_numbers_test(self):
     res = calc.add(1,2)
     self.assertEqual(res, 3)


    
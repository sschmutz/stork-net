import urllib.request
import time

# example of the webcam image address: https://www.berner-storch.ch/webcam/upload/cam01/2020/04/16/21/cam-05.jpg

def download_image(year, month, day, hour, minute):
    """This function takes a timepoint and downloads the webcam image."""

    image_address = f"https://www.berner-storch.ch/webcam/upload/cam01/{year}/{str(month).zfill(2)}/{str(day).zfill(2)}/{str(hour).zfill(2)}/cam-{str(minute).zfill(2)}.jpg"

    # this will be the filename "YYYY-MM-DD_HH-MM"
    date = f"{year}-{str(month).zfill(2)}-{str(day).zfill(2)}_{str(hour).zfill(2)}-{str(minute).zfill(2)}"

    try:
        urllib.request.urlretrieve(image_address, f"../images/{year}/{date}.jpg")
    except:
        print(f"image under the link {image_address} can't be retrieved")


# Example how all images from one month (2019-08) was downloaded
# To not overwhelm the servers, a break of 1min was introduced after downloading
# all images of one day.
# The folder "../images/{year}/" has to be present

# for day in range(1, 32):
#     print("resting for 60s")
#     time.sleep(60)
#     for hour in range(0, 24):
#         for minute in range(0, 60, 5):
#             print(f"downloading image from 2019-08-{str(day).zfill(2)}_{str(hour).zfill(2)}-{str(minute).zfill(2)}")
#             download_image(2019, 8, day, hour, minute)

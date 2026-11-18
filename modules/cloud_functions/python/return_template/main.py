import functions_framework

@functions_framework.http
def testing(request):
    return "Hello World!"
using FluentAssertions;

using Microsoft.AspNetCore.Mvc.Testing;

using Newtonsoft.Json;

namespace IntegrationTests.BloggingContextTests;

public class BlogTest : 
    IClassFixture<CustomWebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public BlogTest(CustomWebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient(new WebApplicationFactoryClientOptions
        {
            AllowAutoRedirect = false
        });
    }
    
    [Fact]
    public async void Given_BlogExists_When_CallingBlogControllerGET_Then_ReturnsSampleDotComBlogJson()
    {
        var blogsResponse = await _client.GetAsync("/Blog");
        var content = JsonConvert.DeserializeObject<List<Blog>>(await blogsResponse.Content.ReadAsStringAsync());
        content.FirstOrDefault()?.Url.Should().Contain("sample.com");
    }
}
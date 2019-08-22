using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Lab2Group4.Startup))]
namespace Lab2Group4
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}

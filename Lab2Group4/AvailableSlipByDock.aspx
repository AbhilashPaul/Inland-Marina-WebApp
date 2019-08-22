<%@ Page Title="Available Slips By Dock" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AvailableSlipByDock.aspx.cs" Inherits="Lab2Group4.AvailableSlipByDock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid" id="mainContainer">
            <!-- Drop down list to view available slips by dock-->
            <div class="form-row py-3 align-middle">
                <span class="col-5 col-md-3 mx-3 align-content-center font-weight-bold h5">Search by docks: </span>
                <asp:DropDownList ID="ddlDocks" runat="server" 
                    AutoPostBack="True" DataSourceID="SqlDataSourceDocks" 
                    DataTextField="Name" DataValueField="ID" 
                    OnSelectedIndexChanged="ddlDocks_SelectedIndexChanged" CssClass="form-control col-5 col-md-3 font-weight-bold">
                </asp:DropDownList>
            </div>

            <!-- Datasource for the drop down list -->
            <asp:SqlDataSource ID="SqlDataSourceDocks" runat="server" ConflictDetection="CompareAllValues" 
                ConnectionString="<%$ ConnectionStrings:MarinaConnectionString %>" 
                DeleteCommand="DELETE FROM [Dock] WHERE [ID] = @original_ID AND [Name] = @original_Name" 
                InsertCommand="INSERT INTO [Dock] ([Name]) VALUES (@Name)" 
                OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT [Name], [ID] FROM [Dock] ORDER BY [ID]" 
                UpdateCommand="UPDATE [Dock] SET [Name] = @Name WHERE [ID] = @original_ID AND [Name] = @original_Name">
                <DeleteParameters>
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Name" Type="String" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Name" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <!-- Available slips display section -->
            <div class="border border-dark mx-1">
                <div class="text-center my-1 font-weight-bold h5">
                    <span>Available Slips</span>
                </div>
                <div class="text-center font-weight-bold">
                    <asp:Label ID="lblPagination" runat="server" CssClass="smaller-text  py-1"></asp:Label>
                </div>
                <div>
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="SlipID" DataSourceID="SqlDataSourceSlipsList" 
                        AllowPaging="True" OnPreRender="GridView1_PreRender"
                        CssClass="table table-borderless table-striped border-0">
                        <Columns>
                            <asp:BoundField DataField="SlipID" HeaderText="Slip ID" SortExpression="ID" 
                                InsertVisible="False" ReadOnly="True" >
                                <HeaderStyle CssClass="text-white bg-info text-center"></HeaderStyle>
                                <ItemStyle CssClass="text-center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="Length" HeaderText="Slip Length" SortExpression="Length">
                                <HeaderStyle CssClass="text-white bg-info text-center"></HeaderStyle>
                                <ItemStyle CssClass="text-center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="Width" HeaderText="Slip Width" >
                                <HeaderStyle CssClass="text-white bg-info text-center"></HeaderStyle>
                                <ItemStyle CssClass="text-center"></ItemStyle>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Water Service">
                                <ItemTemplate>
                                    <asp:CheckBox ID="cbWaterService" runat="server" checked='<%# ((bool)Eval("WaterService")) %>' Enabled="False"/>
                                </ItemTemplate>
                                <HeaderStyle CssClass="text-white bg-info text-center"></HeaderStyle>
                                <ItemStyle CssClass="text-center"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Electrical Service">
                                <ItemTemplate>
                                    <asp:CheckBox ID="cbElectricalService" runat="server" checked='<%# ((bool)Eval("ElectricalService")) %>' Enabled="False"/>
                                </ItemTemplate>
                                <HeaderStyle CssClass="text-white bg-info text-center"></HeaderStyle>
                                <ItemStyle CssClass="text-center"></ItemStyle>
                            </asp:TemplateField>
                        </Columns>
                        <SelectedRowStyle CssClass="bg-light" />
                        <PagerStyle CssClass="w-100 py-2" HorizontalAlign="Center" BackColor="White" />
                        <PagerSettings Mode="NextPreviousFirstLast"
                                        NextpageText="Next" PreviousPageText="Previous"
                                        FirstPageText="First" LastPageText="Last" /> 
                    </asp:GridView>
                </div>

                <!-- Datasource for the data grid view: Available slips from database for the selected dock -->
                <asp:SqlDataSource ID="SqlDataSourceSlipsList" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MarinaConnectionString %>" 
                    SelectCommand="WITH tbl as (
                                    SELECT [DockID], [Slip].[ID] AS [SlipID], [Width], [Length] 
                                    FROM [Slip] LEFT OUTER JOIN [Lease] 
                                    ON [Slip].[ID] = [Lease].[SlipID] 
                                    WHERE [Lease].[SlipID] is null  AND [DockID] =@DockID)
                                    SELECT tbl.SlipID, tbl.Width, tbl.Length, tbl.DockID, WaterService, ElectricalService
                                    FROM tbl
                                    INNER JOIN Dock
                                    ON tbl.DockID = Dock.ID
                                    ORDER BY tbl.SlipID
                                    ">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ddlDocks" Name="DockID" 
                                    PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <br />
            </div>
    </div>
</asp:Content>

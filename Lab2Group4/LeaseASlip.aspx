<%@ Page Title="Lease A Slip" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LeaseASlip.aspx.cs" Inherits="Lab2Group4.LeaseASlip" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid" id="mainContainer">
        <!-- Greeting-->
        <asp:Label ID="lblGreeting" runat="server" Text="Greeting" CssClass="h3 py-4 my-5"></asp:Label>
        
        <div class="border border-primary my-5">
            <div class="form-row py-2">
                <span class="col-5 col-md-3 mx-3 align-content-center font-weight-bold h5">Select a dock: </span>
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
            <div>
                <div class="text-center my-1">
                    <span>Available Slips</span>
                </div>
                <div class="text-center">
                    <asp:Label ID="lblPagination" runat="server" CssClass="smaller-text  py-1"></asp:Label>
                </div>
                <div>
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="SlipID" DataSourceID="SqlDataSourceSlipsList" 
                        CssClass=" table table-sm table-striped table-borderless border-0" 
                        OnSelectedIndexChanged="GridView1_SelectedIndexChanged" AllowPaging="True" OnPreRender="GridView1_PreRender" PageSize="5">
                        <Columns>
                            <asp:BoundField DataField="SlipID" HeaderText="Slip ID" SortExpression="ID" InsertVisible="False" ReadOnly="True" >
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
                            <asp:CommandField ShowSelectButton="True" >
                                <HeaderStyle CssClass="text-white bg-info text-center"></HeaderStyle>
                                <ItemStyle CssClass="text-center"></ItemStyle>
                            </asp:CommandField>
                        </Columns>
                        <SelectedRowStyle CssClass="bg-light" />
                        <PagerStyle CssClass="w-100" HorizontalAlign="Center" />
                        <PagerSettings Mode="NextPreviousFirstLast"
                                        NextpageText="Next" PreviousPageText="Previous"
                                        FirstPageText="First" LastPageText="Last" /> 
                    </asp:GridView>
                </div>
            </div>
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
        
        <!-- Label to display messages to the user -->    
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        
        <!-- Display Leasing History -->
        <div class="my-3 col-12">
            <div class="col-xs-12 col-md-5 float-left">
                <asp:Label ID="lblLease" runat="server" CssClass="h5">Leasing History</asp:Label>
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="ID" DataSourceID="SqlDataSourceLeases" CssClass="table table-sm table-borderless  border border-primary">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="Lease ID" InsertVisible="False" HeaderStyle-CssClass="bg-info text-white" ReadOnly="True" SortExpression="ID" />
                        <asp:BoundField DataField="SlipID" HeaderText="Slip ID" HeaderStyle-CssClass="bg-info text-white" SortExpression="SlipID" />
                    </Columns>
                </asp:GridView>
            </div>

            <div class="col-xs-12 col-md-5">
                <!-- Display for slips selected by the user -->
                <div class="col-12">
                    <p  class="h5">Selected Slips</p>
                    <asp:ListBox ID="lstSlips" runat="server" CssClass="col-12"></asp:ListBox>
                </div>
                <!-- Button to confirm leasing of the slips -->
                <div class="col-12 col-md-4">
                    <asp:Button ID="btnLease" runat="server" Text="Lease Selected  Slips" CssClass="btn btn-info" OnClick="btnLease_Click" />
                </div>
            </div>

        <!-- Leasing History Data Source -->
        <asp:SqlDataSource ID="SqlDataSourceLeases" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MarinaConnectionString %>" 
            SelectCommand="SELECT [ID], [SlipID], [CustomerID] FROM [Lease] 
                            WHERE ([CustomerID] = @CustomerID)">
            <SelectParameters>
                <asp:SessionParameter Name="CustomerID" SessionField="customerid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
    </div>
</asp:Content>

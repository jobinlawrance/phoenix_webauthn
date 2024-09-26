defmodule PhoenixWebauthnWeb.AccountsLiveTest do
  use PhoenixWebauthnWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhoenixWebauthn.LoginFixtures

  @create_attrs %{email: "some email"}
  @update_attrs %{email: "some updated email"}
  @invalid_attrs %{email: nil}

  defp create_accounts(_) do
    accounts = accounts_fixture()
    %{accounts: accounts}
  end

  describe "Index" do
    setup [:create_accounts]

    test "lists all users", %{conn: conn, accounts: accounts} do
      {:ok, _index_live, html} = live(conn, ~p"/users")

      assert html =~ "Listing Users"
      assert html =~ accounts.email
    end

    test "saves new accounts", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("a", "New Accounts") |> render_click() =~
               "New Accounts"

      assert_patch(index_live, ~p"/users/new")

      assert index_live
             |> form("#accounts-form", accounts: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#accounts-form", accounts: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/users")

      html = render(index_live)
      assert html =~ "Accounts created successfully"
      assert html =~ "some email"
    end

    test "updates accounts in listing", %{conn: conn, accounts: accounts} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{accounts.id} a", "Edit") |> render_click() =~
               "Edit Accounts"

      assert_patch(index_live, ~p"/users/#{accounts}/edit")

      assert index_live
             |> form("#accounts-form", accounts: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#accounts-form", accounts: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/users")

      html = render(index_live)
      assert html =~ "Accounts updated successfully"
      assert html =~ "some updated email"
    end

    test "deletes accounts in listing", %{conn: conn, accounts: accounts} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{accounts.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#users-#{accounts.id}")
    end
  end

  describe "Show" do
    setup [:create_accounts]

    test "displays accounts", %{conn: conn, accounts: accounts} do
      {:ok, _show_live, html} = live(conn, ~p"/users/#{accounts}")

      assert html =~ "Show Accounts"
      assert html =~ accounts.email
    end

    test "updates accounts within modal", %{conn: conn, accounts: accounts} do
      {:ok, show_live, _html} = live(conn, ~p"/users/#{accounts}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Accounts"

      assert_patch(show_live, ~p"/users/#{accounts}/show/edit")

      assert show_live
             |> form("#accounts-form", accounts: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#accounts-form", accounts: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/users/#{accounts}")

      html = render(show_live)
      assert html =~ "Accounts updated successfully"
      assert html =~ "some updated email"
    end
  end
end
